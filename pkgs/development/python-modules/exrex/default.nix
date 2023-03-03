{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
}:

buildPythonPackage rec {
  pname = "exrex";
  version = "unstable-2021-04-22";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "exrex";
    rev = "9a66706e7582a9cf31c4121629c9035e329bbe21";
    hash = "sha256-g31tHY+LzGxwBmUpSa0DV7ruLfYwmuDg+XyBxMZRa9U=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/asciimoo/exrex/pull/65
      url = "https://github.com/asciimoo/exrex/commit/44712bfb1350a509581a5834d9fa8aebcd9434db.patch";
      hash = "sha256-thKotSvdVdVjXaG/AhsXmW51FHLOYUeYTYw8SA/k2t4=";
    })
  ];

  # Projec thas no released tests
  doCheck = false;
  pythonImportsCheck = [ "exrex" ];

  meta = with lib; {
    description = "Irregular methods on regular expressions";
    homepage = "https://github.com/asciimoo/exrex";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
