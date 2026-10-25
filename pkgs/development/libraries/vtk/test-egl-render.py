import vtkmodules.vtkRenderingOpenGL2  # noqa: F401 (registers the OpenGL render window factory)
from vtkmodules.vtkFiltersSources import vtkSphereSource
from vtkmodules.vtkRenderingCore import (
    vtkActor,
    vtkPolyDataMapper,
    vtkRenderer,
    vtkRenderWindow,
    vtkWindowToImageFilter,
)

sphere = vtkSphereSource()  # keep a reference: the output port does not own its source
mapper = vtkPolyDataMapper()
mapper.SetInputConnection(sphere.GetOutputPort())
actor = vtkActor()
actor.SetMapper(mapper)
renderer = vtkRenderer()
renderer.AddActor(actor)

window = vtkRenderWindow()
window.SetOffScreenRendering(True)
window.SetSize(64, 64)
window.AddRenderer(renderer)
window.Render()

# Guard against a silent fallback to another window class (X11, OSMesa).
assert window.GetClassName() == "vtkEGLRenderWindow", window.GetClassName()

image = vtkWindowToImageFilter()
image.SetInput(window)
image.Update()
low, high = image.GetOutput().GetPointData().GetScalars().GetRange()
assert high > low, "rendered image is uniform"
