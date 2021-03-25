{ buildPythonPackage
, enum34
, fetchpatch
, fetchPypi
, isPy27
, lib
, mutagen
, six
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o/tSAHu8FTr6LZoMHvegr9uCZovNLHS9KkP2U9y4uko=";
  };

  propagatedBuildInputs = [ mutagen six ] ++ lib.optional isPy27 enum34;

  # NB: Remove in the next release
  patches = [
    (fetchpatch {
      url = "https://github.com/beetbox/mediafile/commit/0ff753d493a1a7f406cb3378545ffe2c85a9afa3.patch";
      sha256 = "sha256-AQ7YedoYPmLqt4a/odgghIKOY61i9YfA0To0RVFqlk8=";
    })
    (fetchpatch {
      url = "https://github.com/beetbox/mediafile/commit/f0fb4e5111d9dfaa3b38d196ec41fcd237d97953.patch";
      sha256 = "sha256-5O6RiAqkQEz3Bvqjwwv/LOS33nSIBnT2H/vasGGVrpI=";
    })
    (fetchpatch {
      url = "https://github.com/beetbox/mediafile/commit/d2fc3b59f77c515b02dfe7ad936f89264375d2b4.patch";
      sha256 = "sha256-SMH0XhCaKLDNB4M8VmZWfGuuelfY5xladZyQYtXtP18=";
    })
  ];

  meta = with lib; {
    description = "MediaFile is a simple interface to the metadata tags for many audio file formats.";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
