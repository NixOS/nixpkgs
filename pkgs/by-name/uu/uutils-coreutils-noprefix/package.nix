{
  uutils-coreutils,
  ...
}@args:

uutils-coreutils.override (
  {
    prefix = null;
  }
  // removeAttrs args [ "uutils-coreutils" ]
)
