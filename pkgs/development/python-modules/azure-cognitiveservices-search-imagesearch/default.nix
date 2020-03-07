{ stdenv, fetchPypi, buildPythonPackage
, azure-common, msrestazure }:

buildPythonPackage rec {
  pname = "azure-cognitiveservices-search-imagesearch";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s8h1ip6ylm030i498bq0wpr3l68my7hbij7jgvj490379v909da";

    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common msrestazure
  ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "Azure SDK for Python";
    homepage = "https://docs.microsoft.com/en-us/azure/python/?view=azure-python";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
