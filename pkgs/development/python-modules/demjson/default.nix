{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "demjson";
  version = "2.2.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygbddpnvp5lby6mr5kz60la3hkvwwzv3wwb3z0w9ngxl0w21pii";
  };

  meta = with stdenv.lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = "https://github.com/dmeranda/demjson";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
