{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    tag = version;
    hash = "sha256-eF/YHKSCMZnavkoX3LcAFHPSPABijn+aPVzaeRYY3WI=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=podcastparser --cov-report html --doctest-modules" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "podcastparser" ];

  meta = with lib; {
    description = "Module to parse podcasts";
    homepage = "http://gpodder.org/podcastparser/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
