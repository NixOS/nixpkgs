{ lib, buildPythonPackage, fetchPypi, mistune_2_0, cjkwrap, wcwidth
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "md2gemini";
  version = "1.9.0";

  propagatedBuildInputs = [ mistune_2_0 cjkwrap wcwidth ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "md2gemini" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d1zuK+NqoPS36ihh8qx9gOET94tApY+SGStsc/bITnU=";
  };

  meta = with lib; {
    description = "Markdown to Gemini text format conversion library";
    homepage = "https://github.com/makeworld-the-better-one/md2gemini";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.kaction ];
  };
}
