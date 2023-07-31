{ stdenv
, lib
, crosstool-ng
, cacert
, writeShellScript
, preferLocalBuild ? true
}:

{ name
, sha256
  # use config from samples
, configFromSample ? ""
  # provide config content
, configContent ? ""
}:

stdenv.mkDerivation {
  pname = "crosstool-ng-src-${name}";
  version = crosstool-ng.version;

  unpackPhase = ''
    if [ ! -z "${configFromSample}" ]
    then
      ct-ng ${configFromSample}
    else
      echo "${configContent}" > .config
    fi

    # override folders in config
    mkdir -p tarballs
    echo CT_LOCAL_TARBALLS_DIR=$PWD/tarballs >> .config
    echo CT_PREFIX_DIR=$PWD/prefix >> .config
  '';

  buildPhase = ''
    unset CC CXX
    ct-ng source
  '';

  installPhase = ''
    mkdir -p $out
    cp -r tarballs $out/
    cp .config $out/
  '';

  nativeBuildInputs = [ crosstool-ng cacert ];
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = sha256;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;

  inherit preferLocalBuild;
}

