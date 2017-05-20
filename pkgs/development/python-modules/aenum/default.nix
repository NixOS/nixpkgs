{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rlhb5wzlyyz0l44r2jxn3m0nh51ifih97dk2y7zfs1m299gwcv6";
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
