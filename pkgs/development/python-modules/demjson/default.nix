{ stdenv, buildPythonPackage, fetchPypi, isPy36 }:

buildPythonPackage rec {
  pname = "demjson";
  version = "2.2.4";
  name = "${pname}-${version}";
  disabled = isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygbddpnvp5lby6mr5kz60la3hkvwwzv3wwb3z0w9ngxl0w21pii";
  };

  meta = with stdenv.lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = http://deron.meranda.us/python/demjson/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
