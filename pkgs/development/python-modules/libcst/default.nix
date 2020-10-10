{ stdenv
, buildPythonPackage
, fetchPypi
, typing-inspect
, pyyaml
, isPy3k
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zgwxdbhz2ljl0yzbrn1f4f464rjphx0j6r4qq0csax3m4wp50x1";
  };

  # The library uses type annotation syntax.
  disabled = !isPy3k;

  propagatedBuildInputs = [ typing-inspect pyyaml ];

  # Test fails with ValueError: No data_provider tests were created for
  # test_type_availability! Please double check your data.
  # The tests appear to be doing some dynamic introspection, not sure what is
  # going on there.
  doCheck = false;
  pythonImportsCheck = [ "libcst" ];

  meta = with stdenv.lib; {
    description = "A concrete syntax tree parser and serializer library for Python that preserves many aspects of Python's abstract syntax tree";
    homepage = "https://libcst.readthedocs.io/en/latest/";
    license = with licenses; [mit asl20 psfl];
    maintainers = [ maintainers.ruuda ];
  };
}
