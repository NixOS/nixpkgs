{
  buildPackages,
  fontconfig,
  lib,
  runCommand,
  stdenv,
}:
let
  fontconfig' = fontconfig;
in
{
  fontconfig ? fontconfig',
  fontDirectories,
}:

runCommand "fc-cache"
  {
    preferLocalBuild = true;
    allowSubstitutes = false;
    passAsFile = [ "fontDirs" ];
    fontDirs = ''
      <!-- Font directories -->
      ${lib.concatStringsSep "\n" (map (font: "<dir>${font}</dir>") fontDirectories)}
    '';
  }
  ''
    export FONTCONFIG_FILE=$(pwd)/fonts.conf

    cat > fonts.conf << EOF
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
    <fontconfig>
      <include>${fontconfig.out}/etc/fonts/fonts.conf</include>
      <cachedir>$out</cachedir>
    EOF
    cat "$fontDirsPath" >> fonts.conf
    echo "</fontconfig>" >> fonts.conf

    # N.B.: fc-cache keys its cache entries by architecture.
    # We must invoke the host `fc-cache` (not the build fontconfig) if we want
    # the cache to be usable by the host.
    mkdir -p $out
    ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe' fontconfig "fc-cache"} -sv

    # This is not a cache dir in the normal sense -- it won't be automatically
    # recreated.
    rm -f "$out/CACHEDIR.TAG"
  ''
