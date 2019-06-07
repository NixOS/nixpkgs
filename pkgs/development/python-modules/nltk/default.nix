{ fetchPypi, buildPythonPackage, lib, six, singledispatch, isPy3k, fetchpatch }:

buildPythonPackage rec {
  version = "3.4.3";
  pname = "nltk";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1cjkv4jmmlr0w4qi399ncgb6lp41mb9i352934288wh9xad15mqj";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPy3k) singledispatch;

  # Tests require some data, the downloading of which is impure. It would
  # probably make sense to make the data another derivation, but then feeding
  # that into the tests (given that we need nltk itself to download the data,
  # unless there's an easy way to download it without nltk's downloader) might
  # be complicated. For now let's just disable the tests and hope for the
  # best.
  doCheck = false;

  meta = {
    description = "Natural Language Processing ToolKit";
    homepage = http://nltk.org/;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
