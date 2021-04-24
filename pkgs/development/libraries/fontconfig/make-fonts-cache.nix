{ runCommand, lib, fontconfig, jq, fontDirectories }:

runCommand "fc-cache"
  {
    nativeBuildInputs = [ fontconfig.bin jq ];
    preferLocalBuild = true;
    allowSubstitutes = false;
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
    <.attrs.json jq .fontDirs >> fonts.conf
    echo "</fontconfig>" >> fonts.conf

    mkdir -p $out
    fc-cache -sv

    # This is not a cache dir in the normal sense -- it won't be automatically
    # recreated.
    rm -f "$out/CACHEDIR.TAG"
  ''
