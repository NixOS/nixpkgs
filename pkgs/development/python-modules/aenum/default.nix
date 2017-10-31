{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.0.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3209fa41b8c41345442e8d9b5158a57d3e96d84c3d5ebbe8e521e1e2eff1598d";
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
