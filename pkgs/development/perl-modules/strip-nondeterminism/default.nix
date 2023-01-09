{ lib
, stdenv
, file
, fetchFromGitLab
, buildPerlPackage
, ArchiveZip
, ArchiveCpio
, SubOverride
, shortenPerlShebang
}:

buildPerlPackage rec {
  pname = "strip-nondeterminism";
  version = "1.13.0";

  outputs = [ "out" "dev" ]; # no "devdoc"

  src = fetchFromGitLab {
    owner = "reproducible-builds";
    repo = "strip-nondeterminism";
    domain = "salsa.debian.org";
    rev = version;
    sha256 = "sha256-KZQeoJYBPJzUvz4wlUZbiGODbpCp7/52dsg5OemKDkI=";
  };

  strictDeps = true;
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ shortenPerlShebang ];
  buildInputs = [
    ArchiveZip
    ArchiveCpio
  ];

  checkInputs = [ SubOverride ];

  postPatch = ''
    substituteInPlace lib/File/StripNondeterminism.pm \
      --replace "exec('file'" "exec('${lib.getExe file}'"
  '';


  postBuild = ''
    patchShebangs ./bin
  '' + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang bin/strip-nondeterminism
  '';

  postInstall = ''
    # we don’t need the debhelper script
    rm $out/bin/dh_strip_nondeterminism
    rm $out/share/man/man1/dh_strip_nondeterminism.1
  '';

  doCheck = true;

  meta = with lib; {
    description = "A Perl module for stripping bits of non-deterministic information";
    homepage = "https://reproducible-builds.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pSub artturin ];
  };
}
