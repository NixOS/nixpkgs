{
  replaceVars,
  version,
}:
replaceVars ./version-patch.patch { JANESTREET_MISSING_VERSION = version; }
