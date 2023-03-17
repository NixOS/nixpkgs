{ buildPythonPackage
, lib
, fetchFromGitHub
, nose
}:
buildPythonPackage rec {
  pname = "d2to1";
  version = "0.2.12.post1";

  nativeCheckInputs = [ nose ];

  src = fetchFromGitHub {
    owner = "embray";
    repo = pname;
    rev = version;
    sha256 = "1hzq51qbzsc27yy8swp08kf42mamag7qcabbrigzj4m6ivb5chi2";
  };

  meta = with lib;{
    description = "Support for distutils2-like setup.cfg files as package metadata";
    homepage = "https://github.com/embray/d2to1";
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
