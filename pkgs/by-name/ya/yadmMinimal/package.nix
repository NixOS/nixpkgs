{
  yadm,
  ...
}@args:
yadm.override (
  {
    withAwk = false;
    withEsh = false;
    withJ2 = false;
    withGpg = false;
    withOpenssl = false;
  }
  // removeAttrs args [ "yadm" ]
)
