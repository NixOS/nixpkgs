{ stdenv, buildPythonPackage, fetchFromGitHub, pytestrunner, pytest, scipy }:

buildPythonPackage {
  pname = "fastpair";
  version = "2016-07-05";

  src = fetchFromGitHub {
    owner = "carsonfarmer";
    repo = "fastpair";
    rev = "92364962f6b695661f35a117bf11f96584128a8d";
    sha256 = "1pv9sxycxdk567s5gs947rhlqngrb9nn9yh4dhdvg1ix1i8dca71";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    scipy
  ];

  # Does not support pytest 4 https://github.com/carsonfarmer/fastpair/issues/14
  doCheck = false;

  checkPhase = ''
    pytest fastpair
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/carsonfarmer/fastpair;
    description = "Data-structure for the dynamic closest-pair problem";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
