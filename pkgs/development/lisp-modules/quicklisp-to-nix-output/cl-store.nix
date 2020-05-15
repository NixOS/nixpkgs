args @ { fetchurl, ... }:
rec {
  baseName = ''cl-store'';
  version = ''20191130-git'';

  parasites = [ "cl-store-tests" ];

  description = ''Serialization package'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-store/2019-11-30/cl-store-20191130-git.tgz'';
    sha256 = ''1pybx08w486d3bmn8fc6zxvxyprc3da24kk3wxhkrgh0fi1vmcbc'';
  };

  packageName = "cl-store";

  asdFilesToKeep = ["cl-store.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-store DESCRIPTION Serialization package SHA256
    1pybx08w486d3bmn8fc6zxvxyprc3da24kk3wxhkrgh0fi1vmcbc URL
    http://beta.quicklisp.org/archive/cl-store/2019-11-30/cl-store-20191130-git.tgz
    MD5 d6052274cd0c6a86bfc2de1e4a8a0886 NAME cl-store FILENAME cl-store DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20191130-git SIBLINGS NIL
    PARASITES (cl-store-tests)) */
