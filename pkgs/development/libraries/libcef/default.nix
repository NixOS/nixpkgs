{ stdenv, callPackage, fetchgit, gtkglext
, libXmu, libXt, libSM, libICE
}:

with stdenv.lib;

let upstreamInfo = callPackage ./upstream.nix { };
    pkg = upstreamInfo.pkg.override {
      enableWideVine = true;
    };

in pkg.mkDerivation (base: rec {
  name = "libcef";
  packageName = "cef";
  # Run "git rev-list --count HEAD" to get this number
  cefVersion = toString upstreamInfo.commitNumber;
  # from CHROMIUM_BUILD_COMPATIBILITY.txt
  upstreamVersion = upstreamInfo.chromiumVersion;
  version = assert base.version == upstreamVersion;
            "${upstreamVersion}-${cefVersion}";

  buildTargets = [ "mksnapshot" "chrome_sandbox" "cef" "cefclient" ];

  outputs = [ "out" "client" ];

  buildInputs = base.buildInputs ++ [
    gtkglext
    # For cefclient
    libXmu libXt libSM libICE
  ];

  cefSrc = fetchgit {
    url = "https://bitbucket.org/chromiumembedded/cef.git";
    inherit (upstreamInfo) rev sha256;
  };

  prePatch = ''
    cp -prvd "${cefSrc}" cef
    chmod -R u+w cef
  '';

  preConfigure = ''
    cd cef

    substituteInPlace tools/make_version_header.py \
      --replace "git.is_checkout('.')" "True" \
      --replace "git.get_commit_number()" '"${cefVersion}"' \
      --replace "git.get_hash()" '"${cefSrc.rev}"'
    substituteInPlace tools/commit_number.py \
      --replace "git.is_checkout('.')" "True" \
      --replace "git.get_commit_number()" '"${cefVersion}"'

    python tools/make_version_header.py \
      --header include/cef_version.h \
      --cef_version VERSION \
      --chrome_version ../chrome/VERSION \
      --cpp_header_dir include

    python tools/patcher.py \
      --patch-config patch/patch.cfg

    cd ..
  '';

  gnFlags = {
    enable_print_preview = false;
  };

  installPhase = ''
    mkdir -p "$libExecPath"
    cp -v "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
    cp -v "$buildPath/icudtl.dat" "$libExecPath/"
    cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
    cp -v "$buildPath/chrome_sandbox" "$libExecPath/chrome-sandbox"

    install -Dm755 "$buildPath/libcef.so" "$out/lib/libcef.so"
    mkdir -p $out/include
    cp -r cef/include $out/include/cef

    install -Dm755 "$buildPath/cefclient" "$client/libexec/cefclient/cefclient"
    for i in "$libExecPath/"*; do
      ln -s "$i" "$client/libexec/cefclient"
    done
    
    mkdir -p "$client/bin"
    ln -s "$client/libexec/cefclient/cefclient" "$client/bin/cefclient"
  '';

  meta = {
    description = "A simple framework for embedding Chromium-based browsers in other applications";
    homepage = http://www.chromium.org/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    requiredSystemFeatures = [ "big-parallel" ];
  };
})
