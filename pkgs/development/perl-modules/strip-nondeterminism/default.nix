{ lib, file, fetchFromGitLab, buildPerlPackage, ArchiveZip, ArchiveCpio }:

buildPerlPackage rec {
  pname = "strip-nondeterminism";
  version = "1.0.0";

  outputs = [ "out" "dev" ]; # no "devdoc"

  src = fetchFromGitLab {
    owner = "reproducible-builds";
    repo = "strip-nondeterminism";
    domain = "salsa.debian.org";
    rev = version;
    sha256 = "1pwar1fyadqxmvb7x4zyw2iawbi5lsfjcg0ps9n9rdjb6an7vv64";
  };

  # stray test failure
  doCheck = false;

  buildInputs = [ ArchiveZip ArchiveCpio file ];

  perlPostHook = ''
    # we don’t need the debhelper script
    rm $out/bin/dh_strip_nondeterminism
    rm $out/share/man/man1/dh_strip_nondeterminism.1.gz
  '';

  meta = with lib; {
    description = "A Perl module for stripping bits of non-deterministic information";
    homepage = "https://reproducible-builds.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
