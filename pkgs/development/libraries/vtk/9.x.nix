import ./generic.nix {
  majorVersion = "9.0";
  minorVersion = "3";
  sourceSha256 = "vD65Ylsrjb/stgUqKrCR/JFAXeQzOw7GjzMjgVFU7Yo=";

  patchesToFetch = [
    # Add missing header includes.
    # https://gitlab.kitware.com/vtk/vtk/-/merge_requests/7611
    {
     url = "https://gitlab.kitware.com/vtk/vtk/-/commit/e066c3f4fbbfe7470c6207db0fc3f3952db633cb.patch";
     sha256 = "ggmDisS3qoMquOqrmIYlCIT7TLxP/DUtW29ktjaEnlM=";
    }
  ];
}
