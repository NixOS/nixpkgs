{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.0.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d98bc55136d696fcf323760c3db0de489da9e41fd51283fa6f90205deb85bf6a";
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
