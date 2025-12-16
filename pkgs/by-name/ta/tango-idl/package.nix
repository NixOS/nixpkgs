{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "tango-idl";
  version = "6.0.4";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "tango-idl";
    tag = version;
    hash = "sha256-etXjey4X5mNCHLtu3TyQv0S9uP4BSfZVNN8YDc/fp68=";
  };

  patches = [
    # corresponds to PR https://gitlab.com/tango-controls/tango-idl/-/merge_requests/31/
    (fetchpatch {
      url = "https://gitlab.com/tango-controls/tango-idl/-/commit/8fd75a4079bf96544697f7783c2de0027d030b8e.patch";
      hash = "sha256-2NMfHakoHzxnYqxVDvH2LnEtLe8S8K88prT9AAs95MA=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Tango CORBA IDL file";
    homepage = "https://gitlab.com/tango-controls/tango-idl";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gilice ];
  };
}
