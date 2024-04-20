{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, marshmallow
, pytest7CheckHook
}:

buildPythonPackage rec {
  pname = "marshmallow-enum";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justanr";
    repo = "marshmallow_enum";
    rev = "v${version}";
    sha256 = "1ihrcmyfjabivg6hc44i59hnw5ijlg1byv3zs1rqxfynp8xr7398";
  };

  postPatch = ''
    sed -i '/addopts/d' tox.ini
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    marshmallow
  ];

  nativeCheckInputs = [
    pytest7CheckHook
  ];

  meta = with lib; {
    description = "Enum field for Marshmallow";
    homepage = "https://github.com/justanr/marshmallow_enum";
    license = licenses.mit;
    maintainers = [ ];
  };
}
