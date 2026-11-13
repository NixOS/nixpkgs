{
  vtk,
  ...
}@args:

vtk.override (
  {
    withQt6 = true;
  }
  // removeAttrs args [ "vtk" ]
)
