args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.18.0'';

  description = ''The Common Foreign Function Interface'';

  deps = [ args."alexandria" args."babel" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
  };

  overrides = x: {
  };
}
