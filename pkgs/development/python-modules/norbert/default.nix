{ lib
, buildPythonPackage
, fetchFromGitHub
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "norbert";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "sigsep";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hr030a8wgb5ndvlcng7ng0cjs1ggnb9vbmp9dwkjyyswn1ga1jd";
  };

  propagatedBuildInputs = [ scipy ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    substituteInPlace setup.cfg --replace '--pep8' ""
  '';
  pytestFlagsArray = [ "tests/" ];

  pythonImportsCheck = [ "norbert" ];

  meta = with lib; {
    description = "Painless Wiener Filters";
    homepage = "https://sigsep.github.io/norbert/";
    license = licenses.mit;
    maintainers = [ maintainers.ris ];
  };
}
