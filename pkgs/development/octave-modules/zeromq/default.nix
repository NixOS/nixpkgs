{
  buildOctavePackage,
  lib,
  fetchurl,
  zeromq,
  pkg-config,
  autoreconfHook,
}:

buildOctavePackage rec {
  pname = "zeromq";
  version = "1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-MAZEpbVuragVuXrMJ8q5/jU5cTchosAtrAR6ElLwfss=";
  };

  preAutoreconf = ''
    cd src
  '';

  postAutoreconf = ''
    cd ..
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  propagatedBuildInputs = [
    zeromq
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/zeromq/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "ZeroMQ bindings for GNU Octave";
  };
}
