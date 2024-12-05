{
  cmake,
  doctest,
  fetchFromGitHub,
  lib,
  replaceVars,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "taskflow";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    rev = "v${version}";
    hash = "sha256-gim1QQKtzMXz8BmNg5YeN4mcveiid5MrS8IrTaTtZ1Y=";
  };

  patches = [
    (replaceVars ./unvendor-doctest.patch {
      inherit doctest;
    })
  ];

  postPatch = ''
    rm -r 3rd-party

    # tries to use x86 intrinsics on aarch64-darwin
    sed -i '/^#if __has_include (<immintrin\.h>)/,/^#endif/d' taskflow/utility/os.hpp
  '';

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    description = "General-purpose Parallel and Heterogeneous Task Programming System";
    homepage = "https://taskflow.github.io/";
    changelog =
      let
        release = lib.replaceStrings [ "." ] [ "-" ] version;
      in
      "https://taskflow.github.io/taskflow/release-${release}.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
