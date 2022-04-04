{
  mkDerivation, fetchpatch,
  extra-cmake-modules, perl,
  karchive, kconfig, kguiaddons, ki18n, kiconthemes, kio, kparts, libgit2,
  qtscript, qtxmlpatterns, sonnet, syntax-highlighting, qtquickcontrols,
  editorconfig-core-c
}:

mkDerivation {
  name = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio libgit2 qtscript
    qtxmlpatterns sonnet syntax-highlighting qtquickcontrols
    editorconfig-core-c
  ];
  propagatedBuildInputs = [ kparts ];
  patches = [
    # Dependency of the next patch
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/ktexteditor/-/commit/da5fced478a91c58ad95ef8925bd92a2e4a45336.patch";
      sha256 = "04w9y99z7n0917q16dfvpiqjvy6rdj0hz4dyavj13jrf4hyasp19";
    })
    # https://kde.org/info/security/advisory-20220131-1.txt
    # CVE-2022-23853
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/ktexteditor/-/commit/804e49444c093fe58ec0df2ab436565e50dc147e.patch";
      sha256 = "0q3vdwylskc0gb1qqga215bpx08al3l8a6m1krf1rxp55yl4jh3k";
    })
    # https://kde.org/info/security/advisory-20220131-1.txt
    # CVE-2022-23853
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/ktexteditor/-/commit/c80f935c345de2e2fb10635202800839ca9697bf.patch";
      sha256 = "1si43sm3x3w73fddpz00jh7nfj1hwsgyw17s3zr8ivn9r61mikpb";
    })
  ];
}
