{ fetchPypi, buildPythonPackage, lib, six, singledispatch, isPy3k, fetchpatch }:

buildPythonPackage rec {
  version = "3.4";
  pname = "nltk";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "286f6797204ffdb52525a1d21ec0a221ec68b8e3fa4f2d25f412ac8e63c70e8d";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPy3k) singledispatch;

  # TODO: remove patch during update to new version
  patches = [
    (fetchpatch {
      url = https://github.com/nltk/nltk/commit/3966111cbf2f35fb86082b2f12acd90d75e9b8bb.patch;
      includes = [ "setup.py" ];
      sha256 = "1sxafnvf6nzv6d996xc1rys06x62s36swgpfqhsyh6l1lj7y38jw";
    })
  ];

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
