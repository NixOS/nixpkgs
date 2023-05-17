{ lib, buildPythonPackage, fetchPypi, mistune, cjkwrap, wcwidth
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "md2gemini";
  version = "1.9.0";

  propagatedBuildInputs = [ mistune cjkwrap wcwidth ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "md2gemini" ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d1zuK+NqoPS36ihh8qx9gOET94tApY+SGStsc/bITnU=";
  };

  meta = with lib; {
    description = "Markdown to Gemini text format conversion library";
    homepage = "https://github.com/makeworld-the-better-one/md2gemini";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
