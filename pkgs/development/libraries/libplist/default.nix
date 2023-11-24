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
  version = "2.3.0";

  outputs = [ "bin" "dev" "out" ] ++ lib.optional enablePython "py";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-fZfDSWVRg73dN+WF6LbgRSj8vtyeKeyjC8pWXFxUmBg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [
    "--enable-debug"
  ] ++ lib.optionals (!enablePython) [
    "--without-cython"
  ];

  doCheck = true;

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.unix;
    mainProgram = "plistutil";
  };
}
