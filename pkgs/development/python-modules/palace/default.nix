{ lib, buildPythonPackage, fetchFromSourcehut, pythonOlder
, cmake, cython, alure2, typing-extensions
}:

buildPythonPackage rec {
  pname = "palace";
  version = "0.2.5";
  disabled = pythonOlder "3.6";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "1z0m35y4v1bg6vz680pwdicm9ssryl0q6dm9hfpb8hnifmridpcj";
  };

  # Nix uses Release CMake configuration instead of what is assumed by palace.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace IMPORTED_LOCATION_NOCONFIG IMPORTED_LOCATION_RELEASE
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [ alure2 ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  doCheck = false; # FIXME: tests need an audio device
  pythonImportsCheck = [ "palace" ];

  meta = with lib; {
    description = "Pythonic Audio Library and Codecs Environment";
    homepage = "https://mcsinyx.gitlab.io/palace";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
