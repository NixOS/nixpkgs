{
  texinfo,
  ...
}@args:

texinfo.override (
  {
    interactive = true;
  }
  // removeAttrs args [ "texinfo" ]
)
