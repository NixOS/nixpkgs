{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
    name = pname + "-" + version;
    pname = "pyext";
    version = "0.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "6c406cf71b991e1fc5a7f963d3a289525bce5e7ad1c43b697d9f5223185fcaef";
    };

    meta = with stdenv.lib; {
      description = "Simple Python extensions.";
      homepage = https://github.com/kirbyfan64/PyExt;
      license = licenses.mit;
      maintainers = with maintainers; [ edwtjo ];
    };
}
