{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
    name = pname + "-" + version;
    pname = "pyext";
    version = "0.7";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1pvwjkrjqajzh4wiiw1mzqp0bb81cqc2gk23nj24m32fpqssc676";
    };

    meta = with stdenv.lib; {
      description = "Simple Python extensions.";
      homepage = "https://github.com/kirbyfan64/PyExt";
      license = licenses.mit;
      maintainers = with maintainers; [ edwtjo ];
    };
}
