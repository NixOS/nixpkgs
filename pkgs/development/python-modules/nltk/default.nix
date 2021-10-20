{ fetchPypi, buildPythonPackage, lib, six, singledispatch ? null, isPy3k
, click
, joblib
, regex
, tqdm
}:

buildPythonPackage rec {
  version = "3.6.5";
  pname = "nltk";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "834d1a8e38496369390be699be9bca4f2a0f2175b50327272b2ec7a98ffda2a0";
  };

  propagatedBuildInputs = [
    click
    joblib
    regex
    tqdm
  ] ++ lib.optional (!isPy3k) singledispatch;

  # Tests require some data, the downloading of which is impure. It would
  # probably make sense to make the data another derivation, but then feeding
  # that into the tests (given that we need nltk itself to download the data,
  # unless there's an easy way to download it without nltk's downloader) might
  # be complicated. For now let's just disable the tests and hope for the
  # best.
  doCheck = false;

  meta = {
    description = "Natural Language Processing ToolKit";
    homepage = "http://nltk.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
