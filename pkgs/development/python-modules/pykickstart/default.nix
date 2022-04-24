{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, polib
, pocketlint
, translation-canary
}:

buildPythonPackage rec {
  pname = "pykickstart";
  version = "3.34";

  src = fetchFromGitHub {
    owner = "pykickstart";
    repo = "pykickstart";
    rev = "r${version}";
    sha256 = "sha256-pWaPRX7UvavmryjGHQJM483gH2mAVyLmyl/9eKbClAo=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "pykickstart" ];
  checkInputs = [ pytestCheckHook polib pocketlint translation-canary ];
  patches = [ ./tests.patch ];

  meta = with lib; {
    homepage = "http://fedoraproject.org/wiki/Pykickstart";
    description = "Read and write Fedora kickstart files";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.govanify ];
  };

}
