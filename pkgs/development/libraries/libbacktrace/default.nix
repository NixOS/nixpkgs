{ stdenv
, lib
, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "libbacktrace";
  version = "unstable-2022-12-16";

  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "da7eff2f37e38136c5a0c8922957b9dfab5483ef";
    sha256 = "ADp8n1kUf8OysFY/Jv1ytxKjqgz1Nu2VRcFGlt1k/HM=";
  };

  configureFlags = [
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "A C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = "https://github.com/ianlancetaylor/libbacktrace";
    maintainers = with maintainers; [ twey ];
    license = with licenses; [ bsd3 ];
  };
}
