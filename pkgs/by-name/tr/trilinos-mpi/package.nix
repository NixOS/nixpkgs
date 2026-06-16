{
  trilinos,
  ...
}@args:

trilinos.override (
  {
    withMPI = true;
  }
  // removeAttrs args [ "trilinos" ]
)
