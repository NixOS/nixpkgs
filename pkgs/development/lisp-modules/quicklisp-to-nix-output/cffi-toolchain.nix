args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-toolchain'';
  version = ''cffi_0.18.0'';

  description = ''The CFFI toolchain'';

  deps = [ args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
  };

  overrides = x: {
  };
}
