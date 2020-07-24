{ lib , buildPythonPackage, fetchFromGitHub, isPy27
, falcon
, pytestrunner
, requests
, pytest
, marshmallow
, mock
, numpy
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "hugapi";
    repo = pname;
    rev = version;
    sha256 = "05rsv16g7ph100p8kl4l2jba0y4wcpp3xblc02mfp67zp1279vaq";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ falcon requests ];

  checkInputs = [ mock marshmallow pytest numpy ];
  checkPhase = ''
    mv hug hug.hidden
    # some tests attempt network access
    PATH=$out/bin:$PATH pytest -k "not (test_request or test_datagram_request)"
  '';

  meta = with lib; {
    description = "A Python framework that makes developing APIs as simple as possible, but no simpler";
    homepage = "https://github.com/timothycrosley/hug";
    license = licenses.mit;
  };

}
