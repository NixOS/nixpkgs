args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.18.0'';

  description = ''The Common Foreign Function Interface'';

  deps = [ args."uiop" args."alexandria" args."trivial-features" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
  };
}
