{ lib
, isPy3k
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, gmpy2
, zope_interface
, python3-application
, cryptography
}:

buildPythonPackage rec {
  pname = "python3-otr";
  version = "2.0.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = version;
    sha256 = "sha256-XsJQIRZj04TkoWIddOc0evXwNFP/IYF/z/nO7mC0aVY=";
  };

  patches = [
    # Apply bugfix commit that is not yet part of a release
    (fetchpatch {
      name = "fix-requirements.patch";
      url = "https://github.com/AGProjects/python3-otr/commit/fbb42e3d288f693b6b2b55cbed327f8b475e937e.patch";
      sha256 = "sha256-xoqKmLPU3es8exHvnn9n9DZdMaZ/BZ4MZsAiCy0Isks=";
    })
    (fetchpatch {
      name = "fix-secret-bytes.patch";
      url = "https://github.com/AGProjects/python3-otr/commit/c5f84a575166794e65611a13a83a0ed3fcd06279.patch";
      sha256 = "sha256-KBpRMeJdrg5RkoMys6zsxyXDemPySRSMZj4/5qAA6w8=";
    })
  ];

  propagatedBuildInputs = [ gmpy2 zope_interface python3-application cryptography ];

  pythonImportsCheck = [ "otr" ];

  meta = with lib; {
    description = "Off-The-Record Messaging protocol implementation for Python";
    homepage = "https://github.com/AGProjects/python3-otr";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ yureien ];
  };
}
