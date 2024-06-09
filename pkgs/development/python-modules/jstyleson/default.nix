{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jstyleson";
  version = "0.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linjackson78";
    repo = "jstyleson";
    # https://github.com/linjackson78/jstyleson/issues/6
    rev = "544b9fdb43339cdd15dd03dc69a6d0f36dd73241";
    hash = "sha256-s/0DDfy+07TuUNjHPqKRT3xMMQl6spZCacB7Dweof7A=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jstyleson" ];

  meta = with lib; {
    description = "A python library to parse JSON with js-style comments";
    homepage = "https://github.com/linjackson78/jstyleson";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
