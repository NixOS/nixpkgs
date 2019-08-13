args @ { fetchurl, ... }:
{
  baseName = ''chipz'';
  version = ''20190202-git'';

  description = ''A library for decompressing deflate, zlib, and gzip data'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chipz/2019-02-02/chipz-20190202-git.tgz'';
    sha256 = ''1vk8nml2kvkpwydcnm49gz2j9flvl8676kbvci5qa7qm286dhn5a'';
  };

  packageName = "chipz";

  asdFilesToKeep = ["chipz.asd"];
  overrides = x: x;
}
/* (SYSTEM chipz DESCRIPTION
    A library for decompressing deflate, zlib, and gzip data SHA256
    1vk8nml2kvkpwydcnm49gz2j9flvl8676kbvci5qa7qm286dhn5a URL
    http://beta.quicklisp.org/archive/chipz/2019-02-02/chipz-20190202-git.tgz
    MD5 e3533408ca6899fe996eede390e820c7 NAME chipz FILENAME chipz DEPS NIL
    DEPENDENCIES NIL VERSION 20190202-git SIBLINGS NIL PARASITES NIL) */
