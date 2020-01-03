{ fetchPypi, buildPythonPackage, lib, six, singledispatch, isPy3k }:

buildPythonPackage rec {
  version = "3.4.5";
  pname = "nltk";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "153x2clrnigs74jdgnn3qmljdjj4gprmvpdvh49i18ls4m8mbm5y";
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
