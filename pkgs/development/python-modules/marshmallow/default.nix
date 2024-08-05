{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  packaging,
  pytestCheckHook,
  pythonOlder,
  pytz,
  simplejson,
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.21.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-WgquzbhNERq6+0wEgpsUXf2zOOVPxK1ICkX5ElVCYP0=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    simplejson
  ];

  pythonImportsCheck = [ "marshmallow" ];

  meta = with lib; {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
