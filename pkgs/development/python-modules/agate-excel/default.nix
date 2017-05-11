{ stdenv, fetchPypi, buildPythonPackage, agate, openpyxl, xlrd }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "agate-excel";
    version = "0.2.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1d28s01a0a8n8rdrd78w88cqgl3lawzy38h9afwm0iks618i0qn7";
    };

    propagatedBuildInputs = [ agate openpyxl xlrd ];

    meta = with stdenv.lib; {
      description = "Adds read support for excel files to agate";
      homepage    = "https://github.com/wireservice/agate-excel";
      license     = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };

}
