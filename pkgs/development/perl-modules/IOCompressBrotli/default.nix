{
  lib,
  brotli,
  buildPerlPackage,
  fetchCpan,
  perlPackages,
  pkg-config,
}:

buildPerlPackage {
  pname = "IO-Compress-Brotli";
  version = "0.019";

  src = fetchCpan {
    pname = "IO-Compress-Brotli";
    version = "0.019";
    author = "TIMLEGGE";
    hash = "sha256-N/QN187kSs6iby92Onc+YdTsIjMF3e7KRhJEPL8oj78=";
  };

  patches = [
    # Use system brotli in Makefile.PL
    ./use-system-brotli.patch
  ];

  postPatch = ''
    substituteInPlace Makefile.PL \
      --replace-fail "@LIBS@" "-L${lib.getLib brotli}/lib -lbrotlienc -lbrotlidec -lbrotlicommon"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    brotli
    perlPackages.FileSlurper
  ];

  propagatedBuildInputs = with perlPackages; [
    FileSlurper
    GetoptLong
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev brotli}/include";

  meta = {
    description = "Write Brotli buffers/streams";
    homepage = "https://github.com/timlegge/perl-IO-Compress-Brotli";
    changelog = "https://github.com/timlegge/perl-IO-Compress-Brotli/blob/main/Changes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
}
