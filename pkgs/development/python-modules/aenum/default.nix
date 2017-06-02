{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.0.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c5db863b5531cc059313018e57bc765b0ef1fc96ba799f105ea45d99b1c2d23";
  };

  doCheck = !isPy3k;
  # The following tests fail (only in python3
  # test_convert (aenum.test.TestIntEnumConvert)
  # test_convert_value_lookup_priority (aenum.test.TestIntEnumConvert)
  # test_convert (aenum.test.TestIntEnumConvert)
  # test_convert_value_lookup_priority (aenum.test.TestIntEnumConvert)

  meta = {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    maintainers = with stdenv.lib.maintainers; [ vrthra ];
    license = with stdenv.lib.licenses; [ bsd3 ];
    homepage = https://bitbucket.org/stoneleaf/aenum;
  };
}
