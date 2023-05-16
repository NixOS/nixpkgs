{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config

, enablePython ? false
, python3
}:

stdenv.mkDerivation rec {
  pname = "libplist";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.0+date=2022-04-05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "bin" "dev" "out" ] ++ lib.optional enablePython "py";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    hash = "sha256-fZfDSWVRg73dN+WF6LbgRSj8vtyeKeyjC8pWXFxUmBg=";
  };

=======
    rev = "db93bae96d64140230ad050061632531644c46ad";
    hash = "sha256-8e/PFDhsyrOgmI3vLT1YhcROmbJgArDAJSe8Z2bZafo=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

<<<<<<< HEAD
  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [
    "--enable-debug"
  ] ++ lib.optionals (!enablePython) [
    "--without-cython"
  ];

  doCheck = true;

=======
  configureFlags = lib.optionals (!enablePython) [
    "--without-cython"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.unix;
<<<<<<< HEAD
    mainProgram = "plistutil";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
