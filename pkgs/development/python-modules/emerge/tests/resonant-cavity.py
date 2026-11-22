import emerge as em
import numpy as np

model = em.Simulation("ResonanceCavity")
cm = 0.01
width = 6 * cm
height = 2 * cm
length = 10 * cm
Nmodes = 3  # Amount of modes to solve for
f = 2e9  # First eigenfreq at around 21GHz

box = em.geo.Box(width, length, height, alignment=em.CENTER)
model.commit_geometry()

model.mw.set_frequency(f)
model.mw.set_resolution(0.1)
model.generate_mesh()
model.view(plot_mesh=True, screenshot="002-01.png", off_screen=True)

data = model.mw.eigenmode(f, nmodes=Nmodes)
# Example: Access the eigenfrequency of the first solution
field = data.field[0]
print(f"Frequency = {field.freq / 1e9:.2f} GHz")
# 2.91GHz

model.display.add_field(
    field.cutplane(ds=0.05 * cm, z=0).scalar("Ez", "real"), cmap="rainbow"
)
model.display.add_field(
    field.cutplane(ds=0.05 * cm, z=height / 3).scalar("Ez", "real"), cmap="rainbow"
)
model.display.add_field(
    field.cutplane(ds=0.05 * cm, z=-height / 3).scalar("Ez", "real"), cmap="rainbow"
)
model.display.populate()
model.display.show(screenshot="002-02.png", off_screen=True)
