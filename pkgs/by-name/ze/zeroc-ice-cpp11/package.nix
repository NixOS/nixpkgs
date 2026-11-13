{
  zeroc-ice,
  ...
}@args:

zeroc-ice.override (
  {
    cpp11 = true;
  }
  // removeAttrs args [ "zeroc-ice" ]
)
